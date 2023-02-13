--奇异转换·高速转换
local s,id,o=GetID()
function s.initial_effect(c)
--SPSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES+CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
function s.tgfi(c)
	return c:IsFaceup() and c:IsSetCard(0x1cc1) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.tgfi(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.tgfi,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.tgfi,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function s.spfi1(c,e,tp,code)
	return c:IsSetCard(0x1cc1) and c:IsCanBeSpecialSummoned(e,0,tp,0,0) and c:IsType(TYPE_MONSTER)
		and not c:IsCode(code)
end
function s.spfi2(c,e,tp,code)
	return c:IsSetCard(0x1cc1) and c:IsCanBeSpecialSummoned(e,0,tp,1,0) and c:IsType(TYPE_FUSION)
		and not c:IsCode(code)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local tc=Duel.GetFirstTarget()
	local res=Duel.TossCoin(tp,1)
	if res==1 then
		if Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(s.spfi1,tp,LOCATION_DECK,0,1,nil,e,tp,tc:GetCode()) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,s.spfi1,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc:GetCode())
			if #sg>0 then Duel.SpecialSummon(sg,0,tp,tp,0,0,POS_FACEUP) end
		end
	elseif res==0 then
		if Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(s.spfi2,tp,LOCATION_EXTRA,0,1,nil,e,tp,tc:GetCode()) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local xg=Duel.SelectMatchingCard(tp,s.spfi2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetCode())
			if #xg>0 then Duel.SpecialSummon(xg,0,tp,tp,1,0,POS_FACEUP) end
		end
	end
end
function s.splimit(e,c)
	return not c:IsSetCard(0x1cc1)
end
