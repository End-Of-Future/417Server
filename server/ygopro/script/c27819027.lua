--圣光飞龙-圣光洗涤
function c27819027.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,c27819027.matfilter1,nil,nil,c27819027.matfilter2,1,99)  
	--Destroy 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)   
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCost(c27819027.accost)
	e1:SetTarget(c27819027.actg)
	e1:SetOperation(c27819027.acop)
	c:RegisterEffect(e1) 
	--to extra & Special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27819027,2))
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e2:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetTarget(c27819027.sptg)
	e2:SetOperation(c27819027.spop)
	c:RegisterEffect(e2)
end
c27819027.SetCard_XXLight=true  
c27819027.SetCard_XXLightDragon=true 
function c27819027.matfilter1(c)
	return c:IsSynchroType(TYPE_TUNER) 
end
function c27819027.matfilter2(c)
	return c:IsSynchroType(TYPE_TUNER) or c:IsSynchroType(TYPE_SYNCHRO) 
end
function c27819027.accost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.CheckLPCost(tp,Duel.GetLP(tp)/2) end 
	Duel.PayLPCost(tp,Duel.GetLP(tp)/2) 
end 
function c27819027.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetChainLimit(c27819027.chlimit)
end
function c27819027.chlimit(e,ep,tp)
	return tp==ep
end
function c27819027.acop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	local x=Duel.Destroy(g,REASON_EFFECT) 
	if x>0 then 
	Duel.Damage(1-tp,x*300,REASON_EFFECT)
	end  
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c27819027.ftarget)
	e1:SetLabel(e:GetHandler():GetFieldID())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c27819027.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
function c27819027.spfilter(c,e,tp)
	return c:IsCode(27819000) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c27819027.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c27819027.spfilter(chkc,e,tp) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c27819027.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c27819027.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsExtraDeckMonster() and Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_EFFECT)~=0
		and c:IsLocation(LOCATION_EXTRA) and tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end



