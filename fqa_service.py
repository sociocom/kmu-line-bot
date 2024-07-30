import pandas as pd
import numpy as np

from sklearn.metrics.pairwise import cosine_similarity
from sentence_transformers import SentenceTransformer


class FaqService:
    def __init__(self, faq_data_path):
        self.data = pd.read_excel(faq_data_path, sheet_name="adviseあり")
        self.diary = self.data["日記"].fillna("")
        self.strict_advice = self.data["厳しいアドバイス"].fillna("")
        self.kind_advice = self.data["優しいアドバイス"].fillna("")
        self.model = SentenceTransformer(
            "sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2"
        )
        self.embeddings = self.model.encode(self.diary.values)

    def find_similar(self, input_text):
        input_embedding = self.model.encode([input_text])
        similarity_scores = cosine_similarity(input_embedding, self.embeddings)
        most_similar_index = np.argmax(similarity_scores)
        return most_similar_index

    def get_response(self, input_text):
        similar_question_index = self.find_similar(input_text)
        strict_responce = self.strict_advice[similar_question_index]
        kind_responce = self.kind_advice[similar_question_index]

        return strict_responce, kind_responce, similar_question_index


# データセットのパス
faq_data_path = "./data/inputs/一行日記_advice作成.xlsx"

# FaqServiceの初期化
faq_service = FaqService(faq_data_path)


def find_answer(input_text) -> str:
    # 応答の取得
    strict_responce, kind_responce, index = faq_service.get_response(input_text)

    return strict_responce, kind_responce, index
