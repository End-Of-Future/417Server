--机械维度 战斗人员·进击型
function c95780034.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x4e11),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--move
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95780034,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,95780034)
	e1:SetTarget(c95780034.seqtg)
	e1:SetOperation(c95780034.seqop)
	c:RegisterEffect(e1)
	--to grave
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_TO_GRAVE)
	e0:SetOperation(c95780034.regop)
	c:RegisterEffect(e0)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(95780034,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,95780035)
	e2:SetCost(c95780034.spcost)
	e2:SetTarget(c95780034.sptg1)
	e2:SetOperation(c95780034.spop1)
	c:RegisterEffect(e2)	
end
function c95780034.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
end
function c95780034.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) or not c:IsControler(tp) or Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local fd=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	Duel.Hint(HINT_ZONE,tp,fd)
	local seq=math.log(fd,2)
	local pseq=c:GetSequence()
	Duel.MoveSequence(c,seq)
	if c:GetSequence()==seq then
		local g=c:GetColumnGroup():Filter(Card.IsFaceup,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(95780034,2)) then
			Duel.BreakEffect()
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function c95780034.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(95780034,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c95780034.cfilter(c,ft,tp)
	return ft>0 or (c:IsControler(tp) and c:GetSequence()<5)
end
function c95780034.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroup(tp,c95780034.cfilter,1,nil,ft,tp) end
	local g=Duel.SelectReleaseGroup(tp,c95780034.cfilter,1,1,nil,ft,tp)
	Duel.Release(g,REASON_COST)
end
function c95780034.spfilter1(c,e,tp)
	return c:IsSetCard(0x4e11) and c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c95780034.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c95780034.spfilter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c95780034.spfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c95780034.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c95780034.spop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end